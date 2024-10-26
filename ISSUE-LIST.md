# Issue List
This contains various issues encountered while working on this project



1. Git Error "RPC failed; HTTP 400 curl 22 The requested URL returned error: 400"
    * Error Message: "error: RPC failed; HTTP 400 curl 22 The requested URL returned error: 400
    send-pack: unexpected disconnect while reading sideband packet"
    * Solution: Increase git buffer with below command
    
        `git config http.postBuffer 524288000`

    