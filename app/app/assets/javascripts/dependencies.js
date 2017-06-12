// Utils
require('whatwg-fetch').fetch;
window.Redux = require('redux/lib/index');

// React
React = require('react');
ReactDOM = require('react-dom');
PropTypes = require('prop-types');

// UI
MUI = require('material-ui');
Typography = require('material-ui/styles/typography');
Colors = require('material-ui/styles/colors');
injectTapEventPlugin = require('react-tap-event-plugin');
injectTapEventPlugin();
MuiThemeProvider = require('material-ui/styles/MuiThemeProvider').default;
