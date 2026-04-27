# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /app

# 1. Copy everything
COPY . .

# 2. DIAGNOSTIC: List all files so we can see the path
RUN ls -R

# 3. Use a wildcards to find the project regardless of folder depth
RUN dotnet restore $(find . -name "*.csproj")
RUN dotnet publish $(find . -name "*.csproj") -c Release -o /out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /out .

ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

# Matches your project name
ENTRYPOINT ["dotnet", "MobileApi.dll"]