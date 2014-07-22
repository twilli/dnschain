###

dnschain
http://dnschain.org

Copyright (c) 2014 okTurtles Foundation

This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.

###

module.exports = (dnschain) ->
    # expose these into our namespace
    for k of dnschain.globals
        eval "var #{k} = dnschain.globals.#{k};"

    class NMCPeer
        constructor: (@dnschain) ->
            # @log = @dnschain.log.child server: "NMC"
            @log = gNewLogger 'NMC'
            @log.debug gLineInfo "Loading NMCPeer..."

            # we want them in this exact order:
            params = ["port", "connect", "user", "password"].map (x)-> gConf.nmc.get 'rpc'+x
            @peer = rpc.Client.create(params...) or gErr "rpc create"
            @log.info "connected to namecoind: %s:%d", params[1], params[0]

        shutdown: ->
            @log.debug gLineInfo 'shutting down!'
            # @peer.end() # TODO: fix this!

        resolve: (path, cb) ->
            @log.debug gLineInfo(), {fn: 'resolve', path: path}
            @peer.call 'name_show', [path], cb
