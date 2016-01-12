# Copyright 2016 Fuzzy.io
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

Microservice = require '../lib/microservice'
Widget = require './widget'

class WidgetService extends Microservice

  getSchema: ->
    {widget: Widget.schema}

  setupRoutes: (exp) ->

    exp.get '/version', (req, res, next) ->
      res.json {name: "widget", version: "0.1.0"}

    exp.post '/widget', @appAuthc, (req, res, next) ->
      Widget.create req.body, (err, widget) ->
        if err
          next err
        else
          res.json widget

    exp.get '/widget', @appAuthc, (req, res, next) ->
      allWidgets = []
      addWidget = (widget) ->
        allWidgets.push widget
      Widget.scan addWidget, (err) ->
        if err
          next err
        else
          res.json allWidgets

    exp.param 'id', @appAuthc, (req, res, next, id) ->
      Widget.get id, (err, widget) ->
        if err
          next err
        else
          req.widget = widget
          next()

    exp.get '/widget/:id', @appAuthc, (req, res, next) ->
      res.json req.widget

    exp.put '/widget/:id', @appAuthc, (req, res, next) ->

    exp.patch '/widget/:id', @appAuthc, (req, res, next) ->
      _.extend req.widget, req.body
      req.widget.save (err, saved) ->
        if err
          next err
        else
          res.json saved

    exp.delete '/widget/:id', @appAuthc, (req, res, next) ->
      req.widget.del (err) ->
        if err
          next err
        else
          res.json {status: "OK"}

    exp

module.exports = WidgetService