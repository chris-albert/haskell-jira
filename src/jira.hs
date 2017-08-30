{-# LANGUAGE OverloadedStrings #-}
import Network.Wreq
import Control.Lens
import Data.ByteString.Char8 as BS
import qualified Data.ByteString.Lazy.Internal as LazyByteString (ByteString)
import Data.Aeson.Lens (key, _String)
import qualified JiraConfig as JC
import Control.Monad.Except

main = do
  jc <- join $ liftIO JC.readDefaultConfig
  jiraRequest jc "hi"

type WSResponse = Response LazyByteString.ByteString

-- protocol = "https"
-- host = "ticketfly.jira.com"
-- username = "chris.albert"
-- password = "T8qNjKs44v73QW26RsKxJLU7"
--
-- baseUrl = protocol ++ "://" ++ host

jiraRequest :: JC.JiraConfig -> String -> IO WSResponse
jiraRequest config endpoint = do
  let baseUrl = JC.protocol config ++ "://" ++ JC.host config
      opts    = defaults & auth ?~ basicAuth (pack (JC.username config)) (pack (JC.password config))
  getWith opts baseUrl

-- getUser :: String -> String -> IO String
-- getUser username password = do
--   let getUserUrl = baseUrl ++ "/rest/api/2/myself"
--       opts       = defaults & auth ?~ basicAuth (pack username) (pack password)
--   resp <- getWith opts getUserUrl
--   let status = resp ^. responseStatus
--       body   = resp ^. responseBody
--   return (show status)
--
-- getIssue :: String -> String -> String -> IO WSResponse
-- getIssue username password issue = do
--   let getIssueUrl = baseUrl ++ "/rest/api/2/issue/" ++ issue
--       opts        = defaults & auth ?~ basicAuth (pack username) (pack password)
--   getWith opts getIssueUrl
--
-- getIssueWithAuth :: String -> IO WSResponse
-- getIssueWithAuth = getIssue username password
--
-- getIssueTitle :: String -> IO String
-- getIssueTitle issue = do
--   resp <- getIssueWithAuth issue
--   let title = resp ^? responseBody . key "fields" . key "summary" . _String
--   return (show title)
