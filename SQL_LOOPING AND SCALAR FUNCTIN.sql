CREATE FUNCTION ADDD_100 (@NUM  INT)
RETURNS DECIMAL
AS
BEGIN 
RETURN(@NUM-100)
END;

DECLARE @COUNTER INT
SET @COUNTER=1
WHILE(@COUNTER <=10)
BEGIN
PRINT'THE COUNTER VALUE IS = ' + CONVERT(VARCHAR, @COUNTER)
SET @COUNTER=@COUNTER+1
END;


DECLARE @X INT 
SET @X=1
WHILE ( @X <= 10)
BEGIN
    PRINT 'The counter value is = ' + CONVERT(VARCHAR,@X)
    SET @X  = @X+1
END


DECLARE @Y INT
SET @Y=1
WHILE(@Y<=12)
BEGIN
PRINT 'PRINTING='+CONVERT(VARCHAR,@Y)
SET @Y=@Y+1
END