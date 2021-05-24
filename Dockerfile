FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
WORKDIR /source/app
COPY ./dotnet-app/*.csproj .
RUN dotnet restore

# copy everything else and build app
COPY ./dotnet-app/. .
RUN dotnet publish -c release -o /publish --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /publish ./
ENTRYPOINT ["./DotNetApp"]
