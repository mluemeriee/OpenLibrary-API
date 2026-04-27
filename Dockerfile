# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source

# 1. Copy the project file from the subfolder
COPY ["MobileApi/MobileApi.csproj", "MobileApi/"]

# 2. Restore dependencies
RUN dotnet restore "MobileApi/MobileApi.csproj"

# 3. Copy everything else and build
COPY . .
WORKDIR "/source/MobileApi"
RUN dotnet publish "MobileApi.csproj" -c Release -o /app/publish

# Run Stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

# Match the casing exactly as seen in your screenshot: MobileApi
ENTRYPOINT ["dotnet", "MobileApi.dll"]