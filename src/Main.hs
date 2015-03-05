{-# OPTIONS_GHC -fno-warn-orphans #-}
import           Application.Types
import           Handler.Admin
import           Handler.Block
import           Handler.Room
import           Handler.Snapshot
import           Handler.Socket
import           Import

import           Control.Concurrent.STM
import           Control.Monad.Logger         (runStderrLoggingT)
import           Control.Monad.Trans.Resource (runResourceT)
import           Database.Persist.Postgresql
import           Yesod.Static

mkYesodDispatch "App" resourcesApp

openConnectionCount :: Int
openConnectionCount = 10

connectionString :: ConnectionString
connectionString = "host=localhost port=5432 user=creek dbname=creek password=creek"

main :: IO ()
main = runStderrLoggingT $ withPostgresqlPool connectionString openConnectionCount $ \pool -> liftIO $ do
    runResourceT $ flip runSqlPool pool $ runMigration migrateAll
    state   <- atomically $ newTVar myState
    channel <- atomically newBroadcastTChan
    s <- static "static"
    --warpEnv requires $PORT to be set
    warpEnv $ App pool (SocketState state channel) s
