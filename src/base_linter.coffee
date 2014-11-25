# Patch the source properties onto the destination.
extend = (destination, sources...) ->
    for source in sources
        (destination[k] = v for k, v of source)
    return destination

# Patch any missing attributes from defaults to source.
defaults = (source, defaults) ->
    extend({}, defaults, source)

module.exports = class BaseLinter

    constructor: (@source, @config, rules) ->
        @setupRules rules

    isObject: (obj) ->
        obj is Object(obj)

    # Create an error object for the given rule with the given
    # attributes.
    createError: (ruleName, attrs = {}) ->
        async.each changedFilesTree, (changedFileTree, eachFileCb) ->
          parentTree = _.find parentRecursiveTree, (parentTree) ->
            parentTree.path is changedFileTree.path

          streamCommitContent parentTree, (err, parentFileSize, parentFileContents) ->
            eachFileCb err

            streamCommitContent changedFileTree, (err, fileSize, fileContents) ->
              return eachFileCb err if err

              contentDiff = diff parentFileContents, fileContents
              levenDelta =  leven fileContents, parentFileContents

              statsObject.changed.delta += levenDelta

    acceptRule: (rule) ->
        throw new Error "acceptRule needs to be overridden in the subclass"

    # Only rules that have a level of error or warn will even get constructed.
    setupRules: (rules) ->
        @rules = []
        for name, RuleConstructor of rules
            level = @config[name].level
            if level in ['error', 'warn']
                rule = new RuleConstructor this, @config
                if @acceptRule(rule)
                    @rules.push rule
            else if level isnt 'ignore'
                throw new Error("unknown level #{level}")

    normalizeResult: (p, result) ->
        if result is true
            return @createError p.rule.name
        if @isObject result
            return @createError p.rule.name, result