dotnet
{
    assembly("Newtonsoft.Json")
    {
        type("Newtonsoft.Json.Linq.JObject"; "JObject")
        {
        }

        type("Newtonsoft.Json.Linq.JProperty"; "JProperty")
        {
        }

        type("Newtonsoft.Json.JsonConvert"; "JsonConvert")
        {
        }

        type("Newtonsoft.Json.Linq.JArray"; "JArray")
        {
        }

        type("Newtonsoft.Json.Formatting"; "Formatting")
        {
        }
    }

    assembly("System.Xml")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.Xml.XmlDocument"; "XmlDocument")
        {
        }
    }

    assembly("System")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.ComponentModel.PropertyChangedEventArgs"; "PropertyChangedEventArgs")
        {
        }

        type("System.ComponentModel.PropertyChangingEventArgs"; "PropertyChangingEventArgs")
        {
        }

        type("System.ComponentModel.ListChangedEventArgs"; "ListChangedEventArgs")
        {
        }

        type("System.ComponentModel.AddingNewEventArgs"; "AddingNewEventArgs")
        {
        }

        type("System.Collections.Specialized.NotifyCollectionChangedEventArgs"; "NotifyCollectionChangedEventArgs")
        {
        }
    }

}
