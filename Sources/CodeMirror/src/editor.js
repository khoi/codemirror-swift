import * as CodeMirror from "codemirror";
import { javascript } from "@codemirror/lang-javascript";
import { html } from "@codemirror/lang-html";
import { json } from "@codemirror/lang-json";
import { xml } from "@codemirror/lang-xml";
import { css } from "@codemirror/lang-css";
import { indentWithTab } from "@codemirror/commands";
import { oneDark } from "@codemirror/theme-one-dark";
import { Compartment } from "@codemirror/state";

const theme = new Compartment();
const language = new Compartment();
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

const SUPPORTED_LANGUAGES = ["javascript", "json", "html", "css", "xml"];

const editorView = new CodeMirror.EditorView({
  doc: '{"fuck": 123}',
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
  ],
  parent: document.body,
});

function toggleDarkTheme(active) {
  editorView.dispatch({
    effects: theme.reconfigure(active ? oneDark : []),
  });
}

function changeLanguage(lang) {
  const langMap = {
    javascript: javascript,
    json: json,
    html: html,
    css: css,
    xml: xml,
  };
  editorView.dispatch({
    effects: language.reconfigure(langMap[lang]()),
  });
}

export { toggleDarkTheme, changeLanguage, SUPPORTED_LANGUAGES };
