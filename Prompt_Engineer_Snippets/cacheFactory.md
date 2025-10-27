Template — convert a method to use _cacheFactory
Goal: Convert an existing public method MethodSignature to a private implementation and add a public cached wrapper MethodName_Cached(...) that uses _cacheFactory.
Inputs (replace these):
•	ProjectPath: e.g. Service\Domain\MemberToClients\MemberToClients.cs
•	InterfacePath: e.g. Service\Interface\IMemberToClients.cs
•	CallerFiles: list files that call the original method (will be updated), e.g. WebApi\Controllers\MemberToClient.cs
•	MethodName: original method name, e.g. GetUserSettings
•	MethodSignature: full signature, e.g. public async Task<ViewModel.UserSettingViewModel> GetUserSettings(Guid memberGuid, Guid clientGuid)
•	CacheKeyPrefix: short cache key label, e.g. GetUserSettings
•	CacheOptions: optional — use SetHybridCacheEntryOptions() or a custom HybridCacheEntryOptions
•	ReturnNullBehavior: whether the cached wrapper should cache null or not (default: preserve original behavior)
Refactor steps:
1.	Change the original method visibility to private and keep its implementation unchanged except for minor internal refactors.
2.	Add a new public method MethodName_Cached with the same parameters and return type that:
•	builds a cache key using HybridCacheFactory.BuildCacheKey(CacheKeyPrefix, param1, param2)
•	returns _cacheFactory.GetOrCreateAsync(cacheKey, async () => await MethodName(...), CacheOptions)
•	use SetHybridCacheEntryOptions() if available
3.	Update the interface at InterfacePath:
•	add Task<ReturnType> MethodName_Cached(...) and remove or replace the original public MethodName entry if you want only cached exposure
4.	Update all callers to call MethodName_Cached(...) instead of the original MethodName(...)
•	search for MethodName( and update relevant call sites, e.g. controllers
5.	Run get_errors / compile checks and run build; fix compilation issues (usings, accessibility, interface mismatches)
6.	Optionally add cache invalidation on Save/Delete/Update by calling _cacheFactory.RemoveAsync(cacheKey) or appropriate removal APIs
7.	Run tests or smoke-test endpoints manually if needed
Behavior & safety notes:
•	Preserve original semantics; private method remains authoritative implementation
•	Do not swallow exceptions in the cached wrapper unless intended
•	Decide explicitly whether null results should be cached; if not, avoid caching null
•	When changing the interface, update DI registrations, unit tests and mocks as needed
Small example (fill placeholders):
•	Change public async Task<ViewModel.UserSettingViewModel> GetUserSettings(Guid memberGuid, Guid clientGuid) to private async Task<ViewModel.UserSettingViewModel> GetUserSettings(Guid memberGuid, Guid clientGuid) { ... }
•	Add public async Task<ViewModel.UserSettingViewModel> GetUserSettings_Cached(Guid memberGuid, Guid clientGuid) that builds cache key "GetUserSettings" and calls _cacheFactory.GetOrCreateAsync(..., () => GetUserSettings(...), SetHybridCacheEntryOptions())
Commit message suggestion: refactor(member-to-clients): switch GetUserSettings to cached wrapper using HybridCacheFactory
