/* eslint no-unused-vars: ["error", { "varsIgnorePattern": "React" }] */
import React from 'react'
import ReactDOM from 'react-dom'
import { mountComponents } from 'react-sinatra-ujs'
import ClientApp from './components/ClientApp'

window.addEventListener('load', function () { mountComponents({ClientApp: ClientApp}) }, false)
