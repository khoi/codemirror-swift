import * as CodeMirror from "codemirror";
import { javascript } from "@codemirror/lang-javascript";
import { html } from "@codemirror/lang-html";
import { json } from "@codemirror/lang-json";
import { xml } from "@codemirror/lang-xml";
import { css } from "@codemirror/lang-css";
import { indentWithTab } from "@codemirror/commands";
import { oneDark } from "@codemirror/theme-one-dark";
import { Compartment } from "@codemirror/state";
import { EditorView } from "@codemirror/view";

import {
  lineNumbers,
  highlightActiveLineGutter,
  highlightSpecialChars,
  drawSelection,
  dropCursor,
  rectangularSelection,
  crosshairCursor,
  highlightActiveLine,
  keymap,
} from "@codemirror/view";

import {
  foldGutter,
  indentOnInput,
  syntaxHighlighting,
  defaultHighlightStyle,
  bracketMatching,
  foldKeymap,
} from "@codemirror/language";

import { history, defaultKeymap, historyKeymap } from "@codemirror/commands";
import { highlightSelectionMatches, searchKeymap } from "@codemirror/search";
import {
  closeBrackets,
  autocompletion,
  closeBracketsKeymap,
  completionKeymap,
} from "@codemirror/autocomplete";

const theme = new Compartment();
const language = new Compartment();
const listener = new Compartment();
const SUPPORTED_LANGUAGES_MAP = { javascript, json, html, css, xml };

const lightTheme = EditorView.theme(
  {
    "&": {
      backgroundColor: "white",
    },
  },
  { dark: false }
);

const editorView = new CodeMirror.EditorView({
  doc: "",
  extensions: [
    lineNumbers(),
    highlightActiveLineGutter(),
    highlightSpecialChars(),
    history(),
    foldGutter(),
    drawSelection(),
    dropCursor(),
    indentOnInput(),
    syntaxHighlighting(defaultHighlightStyle, { fallback: true }),
    bracketMatching(),
    closeBrackets(),
    autocompletion(),
    rectangularSelection(),
    crosshairCursor(),
    highlightActiveLine(),
    highlightSelectionMatches(),
    keymap.of([
      ...closeBracketsKeymap,
      ...defaultKeymap,
      ...searchKeymap,
      ...historyKeymap,
      ...foldKeymap,
      ...completionKeymap,
      indentWithTab,
    ]),
    theme.of(oneDark),
    language.of(json()),
    listener.of([]),
  ],
  parent: document.body,
});

function getSupportedLanguages() {
  return Object.keys(SUPPORTED_LANGUAGES_MAP);
}

function setDarkMode(active) {
  editorView.dispatch({
    effects: theme.reconfigure(active ? oneDark : lightTheme),
  });
}

function setLanguage(lang) {
  editorView.dispatch({
    effects: language.reconfigure(SUPPORTED_LANGUAGES_MAP[lang]()),
  });
}

function setContent(text) {
  editorView.dispatch({
    changes: { from: 0, to: editorView.state.doc.length, insert: text },
  });
}

function setListener(fn) {
  editorView.dispatch({
    effects: listener.reconfigure(
      EditorView.updateListener.of((v) => {
        if (v.docChanged) {
          fn(v.state.doc.toString());
        }
      })
    ),
  });
}

export {
  setDarkMode,
  setLanguage,
  getSupportedLanguages,
  setContent,
  setListener,
  editorView,
};
