using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;

namespace OpenTibiaUnity.Api
{
    public class RafaeLealOpenTibiaSpecApiLocal : IRafaeLealOpenTibiaSpecApi
    {
        public async Task<LoginResult> Login(LoginInfo loginInfo)
        {
            if (loginInfo.Email == "1234" &&
                loginInfo.Password == "1234")
            {
                Debug.Log("Logging in!");
                return new LoginCharacterList()
                {
                    Characters = new List<LoginCharacter>()
                    {
                        new LoginCharacter()
                        {
                            Name = "José",
                            Id = 1,
                            WorldId = 1,
                        },
                        new LoginCharacter()
                        {
                            Name = "Maria",
                            Id = 2,
                            WorldId = 1,
                        }
                    }
                };
            }

            return new LoginError()
            {
                Message = "Unauthorized"
            };
        }

        private bool sentLoginSucess = false;

        private async Task StartLocalBackend(IBackendEventListener listener) {
            while(true) {
                if(!sentLoginSucess) {
                    sentLoginSucess = true;
                    listener.ReceiveEvent(new LoginSuccess()
                    { 
                        PlayerId = 1,
                        BeatDuration = 1,
                        CreatureSpeedA = 0.0f,
                        CreatureSpeedB = 1.0f,
                        CreatureSpeedC = 1.0f,
                        
                        BugReportsAllowed = true,
                        
                        CanChangePvPFrameRate = true,
                        ExportPvPEnabled = true,
                        StoreLink = "https://google.com",
                        StorePackageSize = 20,
                        ExivaRestrictions = true,
                        TournamentActivated = false,
                    });
                }
            }
        }
        public RegisterResult RegisterHandler(IBackendEventListener listener) {
            Task.Run(() => {
                StartLocalBackend(listener);
            }).ConfigureAwait(false);
            return new RegisterSuccess();
        }
    }
}
