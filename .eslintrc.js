module.exports = {
  env: { browser: true, es2020: true },
  extends: ["eslint:recommended"],
  parserOptions: { ecmaVersion: 2020, sourceType: "module" },
  globals: { L: "readonly" },
  rules: { "no-console": "warn" }
}
