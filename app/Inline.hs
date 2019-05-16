import Text.Pandoc.JSON
import System.Process
import GHC.IO.Handle
import qualified Data.ByteString.Base64 as B64
import qualified Data.ByteString.Char8 as C
import Data.Maybe

doInline :: Block -> IO Block
doInline cb@(CodeBlock (id, classes, namevals) contents) =
  case (lookup "cmd" namevals, lookup "fmt" namevals, lookup "echo" namevals) of
    ((Just cmd), (Just fmt), echo) -> do 
      base64 <- runImageCommand cmd contents
      let image = Plain . return $ Image (id, classes, namevals) [] ("data:image/" ++ fmt ++ ";base64," ++ base64, "")
      let code  = CodeBlock ("", [], []) ("```{cmd=\"" ++ cmd ++ "\" fmt=\"" ++ fmt ++ "\"}\n" ++ contents ++ "\n```")
      return . Div ("", [], []) . (image:) $ if isJust echo then [code] else []
    _ -> return cb
doInline x = return x

runImageCommand :: String -> String -> IO String
runImageCommand cmd stdin = do
  (Just hin, Just hout, _, _) <- createProcess $ (shell cmd) {std_out = CreatePipe, std_in = CreatePipe}

  hPutStr hin stdin
  hFlush hin

  hSetBinaryMode hout True
  outStr <- hGetContents hout

  hClose hin

  return . C.unpack . B64.encode . C.pack $ outStr

main :: IO ()
main = toJSONFilter doInline
