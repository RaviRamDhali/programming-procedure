string cartJson = JsonHelpers.HelperSerializeForUI(shoppingcart);


// Serializes json with camelCase for the UI.

public static string HelperSerializeForUI<SerializeType>(SerializeType serializeObject)
		{
			DefaultContractResolver contractResolver = new DefaultContractResolver
			{
				NamingStrategy = new CamelCaseNamingStrategy()
			};

			string json = JsonConvert.SerializeObject(serializeObject, new JsonSerializerSettings
			{
				ContractResolver = contractResolver,
			});

			return json;
		}
