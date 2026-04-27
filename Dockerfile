# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /app

# 1. Copy everything
COPY . .

# 2. Force the build to search the entire system for the project
RUN dotnet restore $(find /app -name "*.csproj")
RUN dotnet publish $(find /app -name "*.csproj") -c Release -o /out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /out .

ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

# This matches the DLL name from your screenshot
ENTRYPOINT ["dotnet", "MobileApi.dll"]