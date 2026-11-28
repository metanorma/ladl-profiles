# LADL profile audit — flavor code + brand guides

Audited: every profile in this repository, against its metanorma
flavor's label vocabulary (the flavor gems' i18n sources and xref
logic) and, where published, the organization's drafting/brand style
guide. Batch reports: SDO core (iso/iec/ieee/ietf/itu/nist), standards
bodies (ogc/bipm/jcgm/jis/gb/plateau), taste flavors (14 profiles); IHO
family (iho/iho_s4/wmo/iala_standard/iala_guideline) in progress.

## Systemic defect found and fixed

Every non-ISO profile was a byte-identical ISO clone whose GLOBAL
templates hardcoded English words — `Formula (%n)`, `%parent, EXAMPLE`,
`List %n` — bypassing the `{formula}`/`{example}`/`{list}` tokens and
with them every host vocabulary. Three flavors ship a different word:
IEC/IEEE/BIPM/BSI/ITU "Equation", IEEE/OIML "Example", OGC "Example",
BIPM "Note", PDF/A "equation". FIXED: all 24 audited profiles now carry
the ISO baseline token patterns (`{formula} (%n)`, `{example}` refs,
`{list}` refs); the flavor word resolves through the host catalog.
Remaining hardcoded words: the IHO-family profiles (batch report
pending).

## False extraction comments corrected

- csa / oiml / oiml_cs / pdfa: claimed "taste i18n carries doctype
  vocabulary only, no label overrides" — false for all four (csa:
  annex Appendix; pdfa: clause section, subclause sub-section, formula
  equation, annex Appendix, tip TIP; oiml: note Note, termnote Note,
  example Example, norm_annex Mandatory; oiml-cs adds inform_annex
  Informative). Corrected.
- swf: claimed inheritance from the IHO stack — false (config.yaml
  declares base-flavor ribose with its own swf.xsl; no IHO reference in
  swf.xsl). Rewritten to the ribose base; the imported IHO
  obligation-gap note removed.
- jcgm: claimed the bipm flavor stack — the taste declares base-flavor
  iso (the bipm gem's clause_jcgm keys apply only on the bipm path).
  Corrected; the JCGM-switch gap note now describes the bipm-gem path.
- mbxif: the ribose clause-subtype gap note was missing; added.

## Profile-level fixes

- plateau: ordered list level 4 uses upper-case alphabet per the
  flavor's ol_type cycle (1 alpha, 2 arabic, 3 roman, 4 ALPHA, 5
  ROMAN). Sequence corrected.

## Engine gaps surfaced (require engine features — owner ruling needed)

1. sourcecode labeller — OGC renders code listings as "Listing"
   (ModSpec); no labeller type exists.
2. admonition labeller — UN "Box", PDF/A "TIP", OIML "termnote" are
   unlabeled; no admonition type exists.
3. obligation-conditional annex labels — IHO/ITU/CC switch Annex ↔
   Appendix by normative/informative obligation; OIML norm_annex
   "Mandatory" / inform_annex "Informative" likewise. The engine needs
   an obligation condition.
4. clause-subtype dispatch — ribose/mbxif render type="section" clauses
   as "Section"; LADL labels all clauses uniformly.
5. hierarchy separators — JIS renders clause levels with "・" and
   figure pairs with "の" (xref clausesep/hierfigsep); PLATEAU uses
   "-". LML patterns hardcode ".".
6. ordered-list level 5 — PLATEAU's cycle has five levels (level 5
   ROMAN upper); the profile set declares four.
7. document-identity condition — BIPM numbers appendices decimally
   (Appendices 1–4) while its JCGM path uses letters; one labeller
   cannot express both without a condition hook.
8. `{appendix}` token — IHO S-4 Part C uses "Appendix"; the token is
   absent from the engine's default vocabulary (it exists in the code
   but not in LABEL_VOCABULARY).

## Brand guides (authoritative sources found)

ISO/IEC: Directives Part 2 9th ed (iso.org). IEC: inherits Part 2.
IEEE: SA Style Manual for Developers. IETF: RFC 7322. ITU: ITU-T
Author's Guide. NIST: Technical Series Author Instructions. OGC: Policy
Directives + ModSpec. BIPM: SI Brochure. JCGM: JCGM 100:2008. JIS: JIS
Z 8301:2019. GB: GB/T 1.1-2020. PLATEAU: MLIT specimen documents. OIML:
OIML B 6-2 Part 2. BSI: BS 0. UN: UN Editorial Manual. CC: CC BY 4.0
legal code. PDF/A: WTPDF 1.0. SWF: IEEE 2874-2025. Ribose/mbxif/
elf/enosema/dsa: none published; flavor i18n is the only source.
