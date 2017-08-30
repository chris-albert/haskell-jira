module JiraConfig (
  JiraConfig(protocol, host, username, password),
  readDefaultConfig,
  endpointConfig
) where

import qualified Data.ConfigFile as CF
import Control.Monad.Except

type JiraConfigIO = IO (Either CF.CPError JiraConfig)

data JiraConfig = JiraConfig {
  protocol :: String,
  host     :: String,
  username :: String,
  password :: String
} deriving Show

defaultConfigLocation = "../config/jira.conf"

readConfig :: String -> JiraConfigIO
readConfig fileName =
  runExceptT $
    do
      cp <- join $ liftIO $ CF.readfile CF.emptyCP fileName
      protocol <- CF.get cp "DEFAULT" "protocol" :: ExceptT CF.CPError IO String
      host     <- CF.get cp "DEFAULT" "host"     :: ExceptT CF.CPError IO String
      username <- CF.get cp "DEFAULT" "username" :: ExceptT CF.CPError IO String
      password <- CF.get cp "DEFAULT" "password" :: ExceptT CF.CPError IO String
      let jc = JiraConfig protocol host username password
      return jc

readDefaultConfig :: JiraConfigIO
readDefaultConfig = readConfig defaultConfigLocation

endpointConfig :: [(String,String)]
endpointConfig = [
  ("self","/rest/api/2/myself"),
  ("issue","/rest/api/2/issue/{{issue}}")
  ]
