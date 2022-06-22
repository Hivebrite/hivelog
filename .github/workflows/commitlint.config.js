// DO NOT EDIT.
// This file is managed by the template repository pipeline.
// https://github.com/Hivebrite/git-template-repository
//
// To edit this file open a PR on repository Hivebrite/git-template-repository

const Configuration = {
  /*
   * Resolve and load @commitlint/config-conventional from node_modules.
   * Referenced packages must be installed
   */
  extends: ['@commitlint/config-conventional'],
  /*
   * Resolve and load conventional-changelog-atom from node_modules.
   * Referenced packages must be installed
   */
  // parserPreset: 'conventional-changelog-atom',
  /*
   * Resolve and load @commitlint/format from node_modules.
   * Referenced package must be installed
   */
  formatter: '@commitlint/format',
  /*
   * Any rules defined here will override rules from @commitlint/config-conventional
   */
  rules: {
    'type-case': [2, 'always', 'lower-case'],
    'type-enum': [2, 'always', [
      'build',
      'chore',
      'ci',
      'deps',
      'docs',
      'feat',
      'fix',
      'perf',
      'refactor',
      'test'
    ]],
    'scope-case': [2, 'always', 'lower-case'],
    'scope-enum': [2, 'always'],
    'subject-case': [2, 'never', ["sentence-case", "start-case", "pascal-case", "upper-case"]],
    'header-max-length': [2, 'always', 142],
    'header-ending-with-jira-ticket': [2, 'always'],
  },
  parserPreset: './commitlint.parser.js',
  plugins: [
    {
      rules: {
        'header-ending-with-jira-ticket': ({ header }) => {
          const regex = /^(.*)\[([A-Z]{1,}-[0-9]+)\]$/;
          const match = regex.exec(header);
          if (match) {
            return [true, `${match[1]}${match[2]}`];
          }
          return [false, 'Your commit header should ending by a JIRA ticket'];
        }
      }
    }
  ],
  /*
   * Functions that return true if commitlint should ignore the given message.
   */
  ignores: [(commit) => commit.includes('[skip-commit-lint]') ],
  /*
   * Whether commitlint uses the default ignore rules.
   */
  defaultIgnores: true,
  /*
   * Custom URL to show upon failure
   */
  helpUrl:
    'https://hivebrite.atlassian.net/l/c/tKU25wtm',
  /*
   * Custom prompt configs
   */
  prompt: {
    messages: {

    },
    questions: {
      type: {
        description: "Select the type of change that you're committing:",
        enum: {
          build: {
            description: 'Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)',
            title: 'Builds',
            emoji: '🛠',
          },
          chore: {
            description: "Other changes that don't modify src or test files",
            title: 'Chores',
            pyemoji: '♻️',
          },
          ci: {
            description: 'Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)',
            title: 'Continuous Integrations',
            emoji: '⚙️',
          },
          deps: {
            description: 'A change that requires all consumers to update their dependencies (example scopes: dependency update, lockfile update)',
            title: 'Dependencies',
            emoji: '🧱'
          },
          docs: {
            description: 'Documentation only changes',
            title: 'Documentation',
            emoji: '📚',
          },
          feat: {
            description: 'A new feature',
            title: 'Features',
            emoji: '✨',
          },
          fix: {
            description: 'A bug fix',
            title: 'Bug Fixes',
            emoji: '🐛',
          },
          perf: {
            description: 'A code change that improves performance',
            title: 'Performance Improvements',
            emoji: '🚀',
          },
          refactor: {
            description: 'A code change that neither fixes a bug nor adds a feature',
            title: 'Code Refactoring',
            emoji: '📦',
          },
          test: {
            description: 'Adding missing tests or correcting existing tests',
            title: 'Tests',
            emoji: '🚨',
          },
        },
      },
    },
  },
};

module.exports = Configuration;
