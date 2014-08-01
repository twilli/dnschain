module.exports = (dnschain) ->
    # expose these into our namespace
    for k of dnschain.globals
        eval "var #{k} = dnschain.globals.#{k};"

    class NXTPeer
        constructor: (@dnschain) ->
            # @log = @dnschain.log.child server: "NMC"
            @log = gNewLogger 'NXT'
            @log.debug "Loading NXTPeer..."
            
            # we want them in this exact order:
            params = ["port", "connect"].map (x)-> gConf.nxt.get x
            
            @peer = 'http://' + params[1] + ":" + params[0] + '/nxt?requestType=getAlias&aliasName=' 
            @log.info "connected to Nxt: %s:%d", params[1], params[0]

        shutdown: ->
            @log.debug 'shutting down!'
            # @peer.end() # TODO: fix this!

        resolve: (path, cb) ->
            @log.debug {fn: 'resolve', path: path}
            req = http.get @peer + path, (res) ->
                data = ''
                res.on 'data', (chunk) ->
                    data += chunk.toString()
                res.on 'end', () ->
                    cb(null, data)
             req.on 'error', ->
                 cb()
