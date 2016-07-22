deps = [
    'ui.router'
    'ui.bootstrap'
    'ngAnimate'
]

configFunc = [
    '$urlRouterProvider'
    '$locationProvider'
    '$stateProvider'
    ($urlRouterProvider, $locationProvider, $stateProvider)->
        $locationProvider.hashPrefix('!')
        $urlRouterProvider.otherwise('/')
        $stateProvider.$state 'main', {
            abstract: true
            template: '/layout.html'
        }
]

angular.module('main', deps)
.config(config)
