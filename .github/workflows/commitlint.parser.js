// DO NOT EDIT.
// This file is managed by the template repository pipeline.
// https://github.com/Hivebrite/git-template-repository
//
// To edit this file open a PR on repository Hivebrite/git-template-repository

//parser-preset.js
module.exports = {
  parserOpts: {
    headerPattern: /^(.*?)(?:\((.+)\))?:\W(.*?)\W?(?:\[([A-Z]+-[0-9]+)\])?$/,
    headerCorrespondence: ['type', 'scope', 'subject', 'ticket'],
  },
};
