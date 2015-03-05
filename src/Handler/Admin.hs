module Handler.Admin where

import           Application.Types
import           Control.Applicative
--import           Data.Time
import           Data.Time.Format (formatTime)
import qualified Data.Text              as T
import           Import
import           System.Locale (defaultTimeLocale)

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

loadSnapshotFormA :: AForm Handler Command
loadSnapshotFormA = LoadSnapshot <$> areq (selectField options) "Lade Snapshot" Nothing
  where
    formatTimestamp = T.pack . formatTime defaultTimeLocale "%d.%m.%Y, %H:%M:%S"
    options = optionsPersistKey [] [Desc SnapshotTimestamp ,LimitTo 5] (\k -> formatTimestamp (snapshotTimestamp k))

loadSnapshotForm :: Html -> MForm Handler (FormResult Command, Widget)
loadSnapshotForm = do
    renderDivs loadSnapshotFormA

getAdminR :: Handler Html
getAdminR = do
  ((_, widget), enctype) <- runFormGet $ loadSnapshotForm
  defaultLayout $ do
    setTitle "Admin Console"

    addStylesheetRemote "//cdn.foundation5.zurb.com/foundation.css"

    [whamlet|
      <div .container-fluid>
          <div .row-fluid>
                <h1> Such Admin. Much Console.
                <form method=get action=@{SnapshotR} enctype=#{enctype}>
                  ^{widget}
                  <button>Snapshot laden
                <form method=post action=@{SnapshotR}>
                  <button>Aktuellen Stand speichern
    |]
