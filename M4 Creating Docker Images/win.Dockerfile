FROM mcr.microsoft.com/dotnet/core/sdk:2.1-nanoserver-1709 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1-nanoserver-1709
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "samplewebapp.dll"]