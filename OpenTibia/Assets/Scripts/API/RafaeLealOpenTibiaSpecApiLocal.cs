using System.Collections.Generic;
using System.Threading.Tasks;

namespace OpenTibiaUnity.Api
{
    public class RafaeLealOpenTibiaSpecApiLocal : IRafaeLealOpenTibiaSpecApi
    {
        public async Task<LoginResult> Login(LoginInfo loginInfo)
        {
            if (loginInfo.Email == "1234" &&
                loginInfo.Password == "1234")
            {
                return new LoginCharacterList()
                {
                    Characters = new List<LoginCharacter>()
                    {
                        new LoginCharacter()
                    }
                };
            }

            return new LoginError()
            {
                Message = "Unauthorized"
            };
        }
    }
}
