# https://hub.docker.com/_/microsoft-dotnet-core
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
WORKDIR /source/app
COPY ./dotnet-app/*.csproj .
RUN dotnet restore

# copy everything else and build app
COPY ./dotnet-app/. .
RUN dotnet publish -c release -o /publish --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build /publish ./
ENTRYPOINT ["./DotNetApp"]
