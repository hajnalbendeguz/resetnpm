import Prelude hiding (catch)
import System.Directory
import Control.Exception
import Control.Concurrent
import System.IO
import System.IO.Unsafe
import System.IO.Error hiding (catch)
import System.FilePath.Posix
import System.Process

removeFileIfExists :: FilePath -> IO ()

removeFileIfExists fileName = removeFile fileName `catch` handleExists
  where handleExists e
          | isDoesNotExistError e = return ()
          | otherwise = throwIO e

removeFolderIfExists :: FilePath -> IO ()

removeFolderIfExists folderName = removeDirectoryRecursive folderName `catch` handleExists
  where handleExists e
          | isDoesNotExistError e = return ()
          | otherwise = throwIO e


currentPath :: FilePath
currentPath = unsafePerformIO $ getCurrentDirectory

nodeModulesPath = currentPath </> "node_modules"
packageLockPath = currentPath </> "package-lock.json"

removeNodeModules = removeFolderIfExists nodeModulesPath
removePackageLockJson = removeFileIfExists packageLockPath
executeNpmI = system "npm i"

main = do
  putStr "Removing node_modules and package-lock.json...\n"
  removeNodeModules
  removePackageLockJson
  putStr "Removed them.\n"
  putStr "Reinstalling packages...\n"
  executeNpmI
  putStr "Done.\n"
