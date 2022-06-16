import { nodeResolve } from "@rollup/plugin-node-resolve";
import { terser } from "rollup-plugin-terser";
export default {
  input: "./editor.js",
  output: {
    file: "./build/editor.bundle.js",
    format: "umd",
    extend: true,
    name: "CodeMirror",
    exports: "named",
    plugins: [terser()],
  },
  plugins: [nodeResolve()],
};
