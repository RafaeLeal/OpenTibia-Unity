using System.Threading.Tasks;

namespace OpenTibiaUnity.Api
{
    public class RafaeLealOpenTibiaSpecApiLocal : IRafaeLealOpenTibiaSpecApi
    {
        public async Task<LoginResult> Login(LoginInfo loginInfo)
        {
            if (loginInfo.Email == "local@here.me" &&
                loginInfo.Password == "1234")
            {
                return new CharacterList() { };
            }

            return new LoginError()
            {
                Message = "Unauthorized"
            };
        }
    }
}
