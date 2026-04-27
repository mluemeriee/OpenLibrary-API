# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /app

# 1. Copy everything from your GitHub root into the container
COPY . .

# 2. Restore and Publish
# We use *.csproj so it finds your project file regardless of the name
RUN dotnet restore *.csproj
RUN dotnet publish *.csproj -c Release -o /out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /out .

# Render's required port
ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

# This must match the name of your .csproj file (MobileApi.dll)
ENTRYPOINT ["dotnet", "MobileApi.dll"]