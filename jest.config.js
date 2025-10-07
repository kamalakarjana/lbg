module.exports = {
    testEnvironment: 'node',
    coverageDirectory: 'coverage',
    collectCoverageFrom: [
        '**/*.js',
        '!**/node_modules/**',
        '!**/coverage/**',
        '!**/test/**',
        '!jest.config.js',
        '!.eslintrc.js',
        '!**/infrastructure/**',
        '!**/kubernetes/**',
        '!**/scripts/**'
    ],
    coverageReporters: [
        'text',
        'lcov',
        'html'
    ],
    testMatch: [
        '**/test/**/*.test.js'
    ],
    testPathIgnorePatterns: [
        '/node_modules/',
        '/infrastructure/',
        '/kubernetes/',
        '/scripts/'
    ],
    verbose: true
};