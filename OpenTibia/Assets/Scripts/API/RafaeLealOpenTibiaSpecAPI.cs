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
    

    public abstract class RegisterResult { }

    public class RegisterSuccess : RegisterResult { }

    public class RegisterError : RegisterResult { }

    public abstract class BackendEvent { }

    ///<summary>
    /// This class represents a successful login after chosing the chracter
    ///</summary>
    public class LoginSuccess : BackendEvent {
        public uint PlayerId { get; set; }
        public ushort BeatDuration { get; set; }
        [CanBeNull] public double CreatureSpeedA { get; set; }
        [CanBeNull] public double CreatureSpeedB { get; set; }
        [CanBeNull] public double CreatureSpeedC { get; set; }
        public bool BugReportsAllowed { get; set; }
        [CanBeNull] public bool CanChangePvPFrameRate { get; set; }
        [CanBeNull] public bool ExportPvPEnabled { get; set; }
        [CanBeNull] public string StoreLink { get; set; }
        [CanBeNull] public ushort StorePackageSize { get; set; }
        [CanBeNull] public bool ExivaRestrictions { get; set; }
        [CanBeNull] public bool TournamentActivated { get; set; }
    }

    public class CharacterLoginError : BackendEvent {
        public string Error { get; set; }
    }

    public class CharacterLoginAdvice : BackendEvent {
        public string Advice { get; set; }
    }

    public class CharacterLoginWait : BackendEvent {
        public string WaitMessage { get; set; }
        public int WaitTime { get; set; }
    }

    public class CharacterLoginToken : BackendEvent {
        public int Unknown { get; set; }
    }

    public class CharacterLoginChallenge : BackendEvent {
        public uint Timestamp { get; set; }
        public byte Challenge { get; set; }
    }

    public class WorldEntered : BackendEvent {}


    public interface IBackendEventListener 
    {
        void ReceiveEvent(BackendEvent backendEvent);
    }

    public interface IRafaeLealOpenTibiaSpecApi
    {
        Task<LoginResult> Login(LoginInfo loginInfo);
        RegisterResult RegisterHandler(IBackendEventListener listener);
    }
}