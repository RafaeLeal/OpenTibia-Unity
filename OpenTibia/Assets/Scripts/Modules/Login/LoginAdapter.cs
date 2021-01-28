using System.Collections.Generic;
using System.Linq;
using OpenTibiaUnity.Api;
using OpenTibiaUnity.Core.Communication.Login;

namespace OpenTibiaUnity.Modules.Login
{
    public class LoginAdapter
    {
        public static CharacterList.Character toCommunicationLoginCharacter(LoginCharacter loginCharacter)
        {
            return new CharacterList.Character()
            {
                Name = loginCharacter.Name,
                WorldId = (int)loginCharacter.WorldId
            };
        } 
        public static CharacterList toCommunicationLoginCharacterList(LoginCharacterList loginCharacterList)
        {
            var characterList = new CharacterList()
            {
                Characters = loginCharacterList.Characters.Select(toCommunicationLoginCharacter).ToList(),
                Worlds = new List<CharacterList.World>()
                {
                    new CharacterList.World()
                    {
                        _id = 1,
                        HostName = "my-test.me",
                        Name = "Local",
                        Port = 4334,
                        Preview = false
                    }
                }
            };
            return characterList;
        }
    }
}