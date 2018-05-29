USE [UATDB01]
GO
/****** Object:  StoredProcedure [dbo].[SP_select_query_engine]    Script Date: 5/29/2018 2:14:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Abirlal Biswas
-- Create date: 5/29/2017 2:14:02 PM
-- Description:	Select Query Generator
-- =============================================
CREATE PROCEDURE [dbo].[SP_select_query_engine]
       @tables VARCHAR(2000),
       @columns VARCHAR(2000), 
       @where VARCHAR(2000), 
       @orWhere VARCHAR(2000), 
       @inValues VARCHAR(2000),
          @customClause VARCHAR(1000),
          @orderBy VARCHAR(255), 
          @groupBy VARCHAR(255),
          @offset VARCHAR(255), 
          @next VARCHAR(255)
AS
BEGIN
       DECLARE @query VARCHAR(4000), @strAllItems VARCHAR(4000)
       DECLARE @columnName VARCHAR(255), @strOperator VARCHAR(255), @colType VARCHAR(10), @colVal VARCHAR(255), @strTbl VARCHAR(255)
       DECLARE @start INT, @end INT, @delimiter1 VARCHAR(10), @strColumnOperator VARCHAR(255), @strColType VARCHAR(255)
       DECLARE @start2 INT, @end2 INT, @delimiter2 VARCHAR(10)
       DECLARE @start3 INT, @end3 INT, @delimiter3 VARCHAR(10)
       DECLARE @start4 INT, @end4 INT, @delimiter4 VARCHAR(10), @colName VARCHAR(255)
       DECLARE @strColumn VARCHAR(255)
       SET @query = 'SELECT '
       SET @strAllItems = @columns
       SET @delimiter1 = '#'
       IF (@columns != '*') BEGIN
              SELECT @start = 1, @end = CHARINDEX(@delimiter1, @strAllItems) 
        WHILE @start < LEN(@strAllItems) + 1 BEGIN 
                           IF @end = 0  SET @end = LEN(@strAllItems) + 1
                           SET @strColumn=SUBSTRING(@strAllItems, @start, @end - @start) 
                                  SET @query = @query + @strColumn +', '
                SET @start = @end + 1 
            SET @end = CHARINDEX(@delimiter1, @strAllItems, @start)
        END
              SET @query=SUBSTRING(@query, 0, LEN(@query)) 
              SET @query = @query + ' FROM '
       END
       ELSE BEGIN
              SET @query = @query + ' * FROM '
       END
       -- IF(@tableName != '0') BEGIN
              -- SET @query = @query + @tableName 
        -- END

       IF (@tables != '0') BEGIN
              SET @strAllItems = @tables 
              SELECT @start = 1, @end = CHARINDEX(@delimiter1, @strAllItems) 
        WHILE @start < LEN(@strAllItems) + 1 BEGIN 
                           IF @end = 0  SET @end = LEN(@strAllItems) + 1
                           SET @strTbl=SUBSTRING(@strAllItems, @start, @end - @start) 
                                  SET @query = @query  + @strTbl +', ' 
                SET @start = @end + 1 
            SET @end = CHARINDEX(@delimiter1, @strAllItems, @start)
        END
              SET @query=SUBSTRING(@query, 0, LEN(@query)) 
              
        END
       

       IF(@where !='0') BEGIN
              SET @query = @query + ' WHERE '
              SET @strAllItems = @where
              SET @delimiter1 = '#'
              SET @delimiter2 = '~'
              SET @delimiter3 = '^'
              SET @delimiter4 = '`'
              SELECT @start = 1, @end = CHARINDEX(@delimiter1, @strAllItems) 
              WHILE @start < LEN(@strAllItems) + 1 BEGIN 
                                  IF @end = 0  SET @end = LEN(@strAllItems) + 1
                                  SET @strColumn=SUBSTRING(@strAllItems, @start, @end - @start) 
                                  SELECT @start2 = 1, @end2 = CHARINDEX(@delimiter2, @strColumn)
                                                         SET @strColumnOperator=SUBSTRING(@strColumn, @start2, @end2) 
                                  SELECT @start3 = 1, @end3 = CHARINDEX(@delimiter3, @strColumnOperator) 
                                  SET @strColType=SUBSTRING(@strColumnOperator, @start3, @end3) 
                                  SET @strOperator=SUBSTRING(@strColumnOperator, @end3 + 1, LEN(@strColumnOperator) ) 
                                  SET @strOperator=SUBSTRING(@strOperator, 0, LEN(@strOperator) ) 
                                  SET @colVal=SUBSTRING(@strColumn, @end2 + 1 , @end2 ) 
                                  SELECT @start4 = 1, @end4 = CHARINDEX(@delimiter4, @strColType) 
                                  SET @colType=SUBSTRING(@strColType, @start4, @end4)
                                  SET @colType=SUBSTRING(@colType, 0, LEN(@colType) ) 
                                  SET @colName=SUBSTRING(@strColType, @end4 + 1, LEN(@strColType))
                                  SET @colName=SUBSTRING(@colName, 0, LEN(@colName) ) 
                                  IF (@colType = 'string') BEGIN
                                         SET @query = @query + @colName + @strOperator + '''' + @colVal + ''' AND '
                                  END 
                                  ELSE BEGIN
                                         SET @query = @query + @colName + @strOperator + @colVal + ' AND '
                                  END
                           SET @start = @end + 1 
                          SET @end = CHARINDEX(@delimiter1, @strAllItems, @start)
              END
              SET @query=SUBSTRING(@query, 0, LEN(@query) - 2) 
        END
        IF(@orWhere !='0') BEGIN
                       IF(@where ='0') BEGIN
                                  SET @query = @query + ' WHERE '
                       END
                       ELSE BEGIN
                                  SET @query = @query + ' OR '
                       END
              SET @strAllItems = @orWhere
              SET @delimiter1 = '#'
              SET @delimiter2 = '~'
              SET @delimiter3 = '^'
              SET @delimiter4 = '`'
              SELECT @start = 1, @end = CHARINDEX(@delimiter1, @strAllItems) 
              WHILE @start < LEN(@strAllItems) + 1 BEGIN 
                                  IF @end = 0  SET @end = LEN(@strAllItems) + 1
                                  SET @strColumn=SUBSTRING(@strAllItems, @start, @end - @start) 
                                  SELECT @start2 = 1, @end2 = CHARINDEX(@delimiter2, @strColumn)
                                                         SET @strColumnOperator=SUBSTRING(@strColumn, @start2, @end2) 
                                  SELECT @start3 = 1, @end3 = CHARINDEX(@delimiter3, @strColumnOperator) 
                                  SET @strColType=SUBSTRING(@strColumnOperator, @start3, @end3) 
                                  SET @strOperator=SUBSTRING(@strColumnOperator, @end3 + 1, LEN(@strColumnOperator) ) 
                                  SET @strOperator=SUBSTRING(@strOperator, 0, LEN(@strOperator) ) 
                                  SET @colVal=SUBSTRING(@strColumn, @end2 + 1 , @end2 ) 
                                  SELECT @start4 = 1, @end4 = CHARINDEX(@delimiter4, @strColType) 
                                  SET @colType=SUBSTRING(@strColType, @start4, @end4)
                                  SET @colType=SUBSTRING(@colType, 0, LEN(@colType) ) 
                                  SET @colName=SUBSTRING(@strColType, @end4 + 1, LEN(@strColType))
                                  SET @colName=SUBSTRING(@colName, 0, LEN(@colName) ) 
                                  IF (@colType = 'string') BEGIN
                                         SET @query = @query + @colName + @strOperator + '''' + @colVal + ''' OR '
                                  END 
                                  ELSE BEGIN
                                         SET @query = @query + @colName + @strOperator + @colVal + ' OR '
                                  END
                           SET @start = @end + 1 
                          SET @end = CHARINDEX(@delimiter1, @strAllItems, @start)
              END
              SET @query=SUBSTRING(@query, 0, LEN(@query) - 2) 
        END
              IF(@customClause !='0') BEGIN                          
                           IF(@orWhere ='0' and @where ='0') BEGIN
                                  SET @query = @query + ' WHERE ' + @customClause + ' '
                           END
                           ELSE BEGIN
                                  SET @query = @query + ' AND ' + @customClause + ' '
                           END                  
              END
              IF(@inValues !='0') BEGIN                       
                           IF(@orWhere ='0' AND @where ='0' AND @customClause ='0') BEGIN
                                  SET @query = @query + ' WHERE '
                           END
                           ELSE BEGIN
                                  SET @query = @query + ' AND '
                           END                        
                           SET @strAllItems  = @inValues
                           SET @delimiter2 = '~'
                SELECT @start2 = 1, @end2 = CHARINDEX(@delimiter2, @strAllItems)
                           SET @strColumn=SUBSTRING(@strAllItems, @start2, @end2 -1)
                           -- SET @strColumn=SUBSTRING(@strAllItems, @start2, @end2)
                           SET @colVal=SUBSTRING(@strAllItems, @end2+1, LEN(@strAllItems))
                           print '@strColumn : ' + @strColumn + '  @strVal : ' + @colVal
                           SET @query = @query + @strColumn + ' IN (' +  @colVal + ') '
              END
              IF(@orderBy !='0') BEGIN                        
                           SET @query = @query + ' ORDER BY ' +  @orderBy + ' '
              END
              IF(@groupBy !='0') BEGIN                        
                           SET @query = @query + ' GROUP BY ' +  @groupBy + ' '
              END
              IF(@offset !='-' AND @next !='-') BEGIN
                     IF(@orderBy !='0') BEGIN
                           SET @query = @query + ' OFFSET ' + @offset + ' ROWS FETCH NEXT ' + @next + ' ROWS ONLY '
                     END 
              END
              
-- print @query
       EXEC(@query)
END

