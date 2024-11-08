module.exports = {
  testEnvironment: "node",
  transform: {
    "^.+\\.tsx?$": ["@swc/jest", {}],
  },
  moduleNameMapper: {
    "^@/(.*)$": "<rootDir>/$1",
  },
  reporters: [
    'default',
    ['jest-html-reporter', {
      pageTitle: 'Test Report',
      outputPath: './test-report.html',
      includeFailureMsg: true,
    }],
  ],
  testTimeout: 10000, // Set global test timeout to 10 seconds
};