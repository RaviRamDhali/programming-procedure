[Table("PasswordToken")]
public class PasswordToken
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public int ID { get; set; }
    public DateTime Created { get; set; }
    public int UserID { get; set; }
    public Guid Token { get; set; }
}

public PasswordToken Create_PasswordToken(PasswordToken model)
{
    return WithConnection(connection =>
    {
        connection.Insert(model);
        return model;
    });

}
