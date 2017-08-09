/* eslint no-unused-vars: ["error", { "varsIgnorePattern": "React" }] */
'use strict'

import React from 'react'
import ReactDOM from 'react-dom'
import ReactDOMServer from 'react-dom/server'
import ClientApp from './components/ClientApp'

// To load on server runtime
global.ClientApp = ClientApp
