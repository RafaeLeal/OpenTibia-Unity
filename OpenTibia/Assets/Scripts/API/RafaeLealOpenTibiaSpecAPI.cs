using System.Collections;
using System.Collections.Generic;
using System.Numerics;
using System.Threading.Tasks;
using JetBrains.Annotations;

namespace OpenTibiaUnity.Api
{

    public class LoginCharacter
    {
       public string Name { get; set; }
       public BigInteger Id { get; set; }
       public BigInteger WorldId { get; set; }
    }
    
    public abstract class LoginResult { }

    public class LoginError : LoginResult {
        [CanBeNull] public string Message { get; set; }
    }

    public class LoginCharacterList : LoginResult
    {
        public List<LoginCharacter> Characters = new List<LoginCharacter>();
    }

    public class LoginInfo
    {
        [CanBeNull] public string Email { get; set; }
        [CanBeNull] public string AccountId { get; set; }
        [CanBeNull] public string Password { get; set; }
    }
    
    public interface IRafaeLealOpenTibiaSpecApi
    {
        Task<LoginResult> Login(LoginInfo loginInfo);
    }
}