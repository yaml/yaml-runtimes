use std::io::{self, Read};

use yaml_rust::{
    parser::{Event, EventReceiver, Parser},
    scanner::{TokenType, TScalarStyle},
};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut data = String::new();
    io::stdin().read_to_string(&mut data)?;
    Parser::new(data.chars())
        .load(&mut Reporter::new(), true)?;
    Ok(())
}

struct Reporter;

impl Reporter {
    fn new() -> Self {
        Self
    }
}

impl EventReceiver for Reporter {
    fn on_event(&mut self, ev: Event) {
        let line: String = match ev {
            Event::StreamStart => "+STR".into(),
            Event::StreamEnd => "-STR".into(),

            Event::DocumentStart => "+DOC".into(),
            Event::DocumentEnd => "-DOC".into(),

            Event::SequenceStart(idx) => format!("+SEQ{}", format_index(idx)),
            Event::SequenceEnd => "-SEQ".into(),

            Event::MappingStart(idx) => format!("+MAP{}", format_index(idx)),
            Event::MappingEnd => "-MAP".into(),

            Event::Scalar(ref text, style, idx, ref tag) => {
                let kind = match style {
                    TScalarStyle::Plain => ":",
                    TScalarStyle::SingleQuoted => "'",
                    TScalarStyle::DoubleQuoted => r#"""#,
                    TScalarStyle::Literal => "|",
                    TScalarStyle::Foled => ">",
                    TScalarStyle::Any => unreachable!(),
                };
                let tag = format_tag(tag);
                format!("=VAL{}{} {}{}", format_index(idx), tag, kind, format_text(text))
            }
            Event::Alias(idx) => format!("=ALI *{}", idx),
            _ => return,
        };
        println!("{}", line);
    }
}

fn format_index(idx: usize) -> String {
    if idx > 0 {
        format!(" &{}", idx)
    } else {
        "".into()
    }
}

fn format_text(text: &str) -> String {
    let mut text = text.to_owned();
    if text.eq("~") {
        return "".to_string()
    }
    for (ch, replacement) in [
        ('\\', r#"\\"#),
        ('\n', "\\n"),
        ('\r', "\\r"),
        ('\x08', "\\b"),
        ('\t', "\\t"),
    ] {
        text = text.replace(ch, replacement);
    }
    text
}

fn format_tag(tag: &Option<TokenType>) -> String {
    if let Some(TokenType::Tag(ns, tag)) = tag {
        let ns = match ns.as_str() {
            "!!" => "tag:yaml.org,2002:", // Wrong if this ns is overridden
            other => other,
        };
        format!(" <{}{}>", ns, tag)
    } else {
        "".into()
    }
}
