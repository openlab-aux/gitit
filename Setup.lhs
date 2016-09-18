#!/usr/bin/env runhaskell
> import Distribution.Simple
> import System.Process (callProcess)

Call our script that downloads the frontend dependencies.

> fetchDependencies = callProcess "./fetchDependencies.sh" []

Combine the default simpleUserHooks with our fetchDependencies hook.

> preConfHook args flags  = do
>   (preConf simpleUserHooks) args flags
>   fetchDependencies
>   return mempty

Not exactly needed preConf actually but it doesn't hurt to do it that early.

> main = defaultMainWithHooks $ simpleUserHooks { preConf = preConfHook }
