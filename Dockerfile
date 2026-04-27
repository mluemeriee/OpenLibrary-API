# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /app

# Copy everything from the current folder into the container
COPY . .

# Since the .csproj is in the same folder as this Dockerfile, 
# we don't need subfolder paths anymore.
RUN dotnet restore
RUN dotnet publish -c Release -o /out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /out .

ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

# This must match your project name
ENTRYPOINT ["dotnet", "MobileApi.dll"]