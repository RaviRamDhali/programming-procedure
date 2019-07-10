Declare @strRawPhone varchar(100)
Declare @strResultPhone varchar(100)

    set @strRawPhone = '444ABC-222*1111XYZ'
    set @strResultPhone = ''

	print 'input: ' + @strRawPhone

    select
        @strResultPhone = @strResultPhone +
                case when number like '[0-9]' then number else '' end from 
        (
             select substring(@strRawPhone,number,1) as number from 
            (
                select number from master..spt_values 
                where type='p' and number between 1 and len(@strRawPhone)
            ) as t
        ) as t

select @strResultPhone as only_numbers
