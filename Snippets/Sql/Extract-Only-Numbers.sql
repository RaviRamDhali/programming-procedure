 Declare @s varchar(100),@result varchar(100)
    set @s='as4khd0939sdf78' 
    set @result=''

    select
        @result=@result+
                case when number like '[0-9]' then number else '' end from 
        (
             select substring(@s,number,1) as number from 
            (
                select number from master..spt_values 
                where type='p' and number between 1 and len(@s)
            ) as t
        ) as t 
    select @result as only_numbers 
