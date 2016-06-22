mod = undefined
mod = angular.module('infinite-scroll', [])
mod.directive 'infiniteScroll', [
  '$rootScope'
  '$window'
  '$timeout'
  ($rootScope, $window, $timeout) ->
    { link: (scope, elem, attrs) ->
      checkWhenEnabled = undefined
      handler = undefined
      scrollDistance = undefined
      scrollEnabled = undefined
      $window = angular.element($window)
      $document = angular.element(document)
      scrollDistance = 0
      if attrs.infiniteScrollDistance != null
        scope.$watch attrs.infiniteScrollDistance, (value) ->
          scrollDistance = parseInt(value, 10)
      scrollEnabled = true
      checkWhenEnabled = false
      if attrs.infiniteScrollDisabled != null
        scope.$watch attrs.infiniteScrollDisabled, (value) ->
          scrollEnabled = !value
          if scrollEnabled and checkWhenEnabled
            checkWhenEnabled = false
            return handler()
          return

      handler = ->
        elementBottom = undefined
        remaining = undefined
        shouldScroll = undefined
        elementBottom = elem.offset().top + elem.height()
        #remaining = elementBottom - windowBottom;
        shouldScroll = (scrollDistance * 0.1) >= (1 - ( $window.scrollTop() / ( $document.height() - $window.height() ) ) )
        if shouldScroll and scrollEnabled
          if $rootScope.$$phase
            return scope.$eval(attrs.infiniteScroll)
          else
            return scope.$apply(attrs.infiniteScroll)
        else if shouldScroll
          return checkWhenEnabled = true
        return

      $window.on 'scroll', handler
      scope.$on '$destroy', ->
        $window.off 'scroll', handler
      $timeout (->
        if attrs.infiniteScrollImmediateCheck
          if scope.$eval(attrs.infiniteScrollImmediateCheck)
            return handler()
        else
          return handler()
        return
      ), 0
 }
]