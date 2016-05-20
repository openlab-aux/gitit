{-# LANGUAGE LambdaCase #-}
module Network.Gitit.MetaInformation
  ( module X
  , getDataFileName
  ) where

import Paths_gitit as X hiding (getDataFileName)
import qualified Paths_gitit as Paths
import System.Environment (lookupEnv)
import System.FilePath ((</>))


getDataFileName :: FilePath -> IO FilePath
getDataFileName fp = do
  lookupEnv "GITIT_STATIC_DIR" >>= \case
      Just p  -> pure $ p </> fp
      Nothing -> Paths.getDataFileName fp
