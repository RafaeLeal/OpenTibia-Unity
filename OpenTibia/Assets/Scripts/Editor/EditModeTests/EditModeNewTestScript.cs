using System.Collections;
using NUnit.Framework;
using OpenTibiaUnity.Api;
using UnityEngine.TestTools;

namespace OpenTibiaUnity.Editor.EditModeTests
{
    public class EditModeNewTestScript
    {
        // A Test behaves as an ordinary method
        [Test]
        public void EditNewTestScriptSimplePasses()
        {
            // Use the Assert class to test conditions
            var spec = new RafaeLealOpenTibiaSpecApiLocal();
        }

        // A UnityTest behaves like a coroutine in Play Mode. In Edit Mode you can use
        // `yield return null;` to skip a frame.
        [UnityTest]
        public IEnumerator EditNewTestScriptWithEnumeratorPasses()
        {
            // Use the Assert class to test conditions.
            // Use yield to skip a frame.
            yield return null;
        }
    }
}
