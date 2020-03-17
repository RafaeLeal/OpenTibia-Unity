using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using JetBrains.Annotations;

namespace OpenTibiaUnity.Api
{

    public class Character
    {
        
    }
    
    public abstract class LoginResult { }

    public class LoginError : LoginResult {
        [CanBeNull] public string Message { get; set; }
    }

    public class CharacterList : LoginResult
    {
        public List<Character> Characters = new List<Character>();
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