# Stage 1: Build using the .NET 10 SDK
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /source

# Copy everything from your repo
COPY . .

# Move into the folder where the project lives (from your screenshot)
WORKDIR /source/MobileApi

# Restore and Publish for release
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Run using the .NET 10 ASP.NET Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app/publish .

# Render's required port configuration
ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

# Matches your 'MobileApi.csproj' name exactly
ENTRYPOINT ["dotnet", "MobileApi.dll"]