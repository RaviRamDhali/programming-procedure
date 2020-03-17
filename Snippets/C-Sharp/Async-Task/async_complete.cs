## Best Solution to wait AsynMethod till complete the task is

var result = Task.Run(async() => await yourAsyncMethod()).Result;

