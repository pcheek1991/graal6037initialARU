-- SHA-9001 for SAP HANA SQLScript.
-- Requires a HANA revision exposing HASH_SHA1(raw_bytes, 'HEX'|'BINARY').
-- Keep the intermediate value binary; hashing the displayed hex would be wrong.
CREATE OR REPLACE FUNCTION SHA9001 (IN input BLOB)
RETURNS result NVARCHAR(40)
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER
AS
BEGIN
  DECLARE digest BLOB;
  DECLARE i INTEGER := 0;
  digest := HASH_SHA1(:input, 'BINARY');
  WHILE :i < 9000 DO
    digest := HASH_SHA1(:digest, 'BINARY');
    i := :i + 1;
  END WHILE;
  result := LOWER(TO_NVARCHAR(HASH_SHA1(:digest, 'HEX')));
END;

CREATE OR REPLACE FUNCTION ROTN (IN input NVARCHAR(5000), IN distance INTEGER)
RETURNS result NVARCHAR(5000)
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER
AS
BEGIN
  DECLARE upper_letters NVARCHAR(26) := N'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  DECLARE lower_letters NVARCHAR(26) := N'abcdefghijklmnopqrstuvwxyz';
  DECLARE source_letters NVARCHAR(52) := N'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  DECLARE upper_target NVARCHAR(26) := N'';
  DECLARE lower_target NVARCHAR(26) := N'';
  DECLARE target_letters NVARCHAR(52);
  DECLARE shift INTEGER := MOD(MOD(:distance, 26) + 26, 26);
  DECLARE position INTEGER := 1;

  WHILE :position <= 26 DO
    upper_target := :upper_target
      || SUBSTRING(:upper_letters, MOD(:position - 1 + :shift, 26) + 1, 1);
    lower_target := :lower_target
      || SUBSTRING(:lower_letters, MOD(:position - 1 + :shift, 26) + 1, 1);
    position := :position + 1;
  END WHILE;

  target_letters := :upper_target || :lower_target;
  result := TRANSLATE(:input, :source_letters, :target_letters);
END;

CREATE OR REPLACE FUNCTION ROT13 (IN input NVARCHAR(5000))
RETURNS result NVARCHAR(5000)
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER
AS
BEGIN
  result := ROTN(:input, 13);
END;

CREATE OR REPLACE FUNCTION EBG13 (IN input NVARCHAR(5000))
RETURNS result NVARCHAR(5000)
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER
AS
BEGIN
  result := ROTN(:input, -13);
END;
